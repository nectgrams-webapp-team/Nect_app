class ActivitiesController < ApplicationController
  require "mini_magick"

  def index
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @activities = Activity.joins(:member)
                            .where('activities.published = ? AND (activities.title LIKE ? OR activities.body LIKE ? OR members.name LIKE ?)', true, search_term, search_term, search_term)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(10)
    else
      @activities = Activity.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @author = @activity.member
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params.except(:activity_image))
    # puts "DEBUG: params[:activity][:activity_image] = #{params[:activity][:activity_image].inspect}"
    # 画像がアップロードされている場合のみ処理
    if params[:activity][:activity_image].present?
      compressed_image = compress_image(params[:activity][:activity_image], "new")
      @activity.activity_image.attach(
        io: compressed_image,
        filename: "#{File.basename(params[:activity][:activity_image].original_filename, '.*')}.jpg",
        content_type: "image/jpeg"
      )
    end
    @activity.member_id = current_member.id

    if @activity.save
      redirect_to activities_path
    else
      flash[:alert] = "プレビューを表示したい場合は、エラー内容を修正後に一度保存して、編集を実行してください。"

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    unless @activity.member == current_member
      redirect_to activity_path(params[:id])
    end
  end

  def update
    @activity = Activity.find(params[:id])
    # puts "DEBUG: params[:activity][:activity_image] = #{params[:activity][:activity_image].inspect}"
    if params[:activity][:activity_image].present?
      compressed_image = compress_image(params[:activity][:activity_image], "edit")
      # 既存の画像を削除
      @activity.activity_image.purge if @activity.activity_image.attached?
      # 圧縮後の画像をアップロード
      @activity.activity_image.attach(
        io: compressed_image,
        filename: "#{File.basename(params[:activity][:activity_image].original_filename, '.*')}.jpg",
        content_type: "image/jpeg"
      )
    end

    if @activity.update(activity_params.except(:activity_image))
      redirect_to activity_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.delete
    redirect_to activities_path
  end

  def save_draft
    @activity = Activity.new(activity_params)
    # 画像がアップロードされている場合のみ処理
    if params[:activity][:activity_image].present?
      compressed_image = compress_image(params[:activity][:activity_image], "new")
      @activity.activity_image.attach(
        io: compressed_image,
        filename: "#{File.basename(params[:activity][:activity_image].original_filename, '.*')}.jpg",
        content_type: "image/jpeg"
      )
    end
    @activity.member_id = current_member.id
    @activity.published = false

    if @activity.save
      redirect_to activities_path, notice: '下書きが保存されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def change_publish
    @activity = Activity.find(params[:id])

    if params[:activity][:activity_image].present?
      compressed_image = compress_image(params[:activity][:activity_image], "edit")
      # 既存の画像を削除
      @activity.activity_image.purge if @activity.activity_image.attached?
      # 圧縮後の画像をアップロード
      @activity.activity_image.attach(
        io: compressed_image,
        filename: "#{File.basename(params[:activity][:activity_image].original_filename, '.*')}.jpg",
        content_type: "image/jpeg"
      )
    end

    if @activity.published
      @activity.published = false
      notice_message = '記事が非公開になりました。'
    else
      @activity.published = true
      notice_message = '記事が公開されました。'
    end

    if @activity.update(activity_params.except(:activity_image))
      redirect_to activity_path(@activity), notice: notice_message
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :body, :activity_image, :published)
  end

  def compress_image(uploaded_file, action)
    image = MiniMagick::Image.open(uploaded_file.tempfile.path)
    # # 画像を圧縮・リサイズ
    if image.width > 840
      image.resize "840x"
    else
      image.quality "50"
    end
    image.format "jpeg"

    tempfile = Tempfile.new(["compressed", ".jpg"])
    image.write(tempfile.path)
    tempfile.rewind

    # アクション別に扱うデータを分ける
    if action == "new"
      io = StringIO.new(tempfile.read)
      io.rewind
      io
    else
      tempfile
    end
  end
end
