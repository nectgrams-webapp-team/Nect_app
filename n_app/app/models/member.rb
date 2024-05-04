class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 学籍番号かどうか確認
  validates :student_id, presence: true, format: { with: /\A[a-zA-Z]{2}\d{4,}\z/ }


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
end
