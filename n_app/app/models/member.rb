class Member < ApplicationRecord
  has_many :activities, dependent: :destroy

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリテーションの設定
  validates :student_id, presence: true, format: { with: /\A[a-zA-Z]{2}\d{4,}\z/ }
  validates :name, presence: true


  def calculate_grade(student_id)
    # 学籍番号から入学年の下二桁を取得
    enrollment_year = student_id[2..3].to_i
    # 現在の年の下二桁を取得
    current_year_last_two_digits = Date.today.year % 100
    # 現在の月が4月以前の場合、学年の計算で前年を使用
    current_year_last_two_digits -= 1 if Date.today.month < 4
    # 入学年から現在の年までの差を計算し、学年を求める
    grade = current_year_last_two_digits - enrollment_year + 1

    # 4年を超える場合は 'OM' を返す
    grade > 4 ? 'OM' : grade
  end

  PROGRAMMING_LANGUAGES = {
    1 => "Ruby",
    2 => "C",
    4 => "C#",
    8 => "C++",
    16 => "Python"
  }.freeze

  def calculate_select_pl(select_pl)
    s_pl = []
    PROGRAMMING_LANGUAGES.each do |key,val|
      if (select_lp & key) != 0
        s_pl.push(val)
      end
    end
    s_lp.join(" , ")
  end

end
