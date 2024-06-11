class MembersController < ApplicationController
  def index
    @members = Member.all
    respond_to do |format|
      format.html
      format.xlsx do
        filename = "data_export_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
        
        p = Axlsx::Package.new
        p.workbook.add_worksheet(name: "Member Data Sheet") do |sheet|
          
          headers = Member.column_names
          sheet.add_row headers

          @members.each do |record|
            values = record.attributes.values
            sheet.add_row values
          end
        end

        send_data p.to_stream.read, filename: filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  def show
    @member = Member.find(params[:id])
    @member.grade = @member.calculate_grade(@member.student_id)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])

    #選択された言語の値を合計
    selected_languages = Array(members_params[:selected_languages]).map(&:to_i)
    total_value = selected_languages.sum
    @member.learning_programming_languages = total_value

    #selected_languagesを除外してパラメータ保存
    if @member.update(members_params.except(:selected_languages))
      redirect_to member_path(@member.id)
    else
      render :edit
    end
  end

  private
  def members_params
    params.require(:member).permit(:name, :email, :student_id, :intro, :profile_image, :department, selected_languages: [])
  end
end
