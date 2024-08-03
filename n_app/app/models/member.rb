class Member < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  # バリテーションの設定
  validates :student_id, presence: true, format: { with: /\A[a-zA-Z]{2}\d{4,}\z/ }
  validates :name, presence: true

  has_many :activities, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, :through => :team_members

  enum :member_role, { user: 0, mod: 1, admin: 2 }
  enum :grade, { '1年生': '1', '2年生': '2', '3年生': '3', '4年生': '4', 'OM': '5' }
  enum :department, { "情報工学科": 1, "デジタルエンタテインメント学科": 2 }

  def calculate_graduation_year(student_id)
    # 学籍番号から入学年の下二桁を取得
    enrollment_year = student_id[2..3].to_i
    # 現在の年の下二桁を取得
    current_year_last_two_digits = Date.today.year % 100
    # 現在の月が4月以前の場合、学年の計算で前年を使用
    current_year_last_two_digits -= 1 if Date.today.month < 4
    # 入学年から現在の年までの差を計算し、学年を求める
    grade = current_year_last_two_digits - enrollment_year + 1
    # 卒業年
    graduation_year = enrollment_year + 4
  end

  PROGRAMMING_LANGUAGES = {
    1 => "C",
    2 => "C++",
    4 => "C#",
    8 => "Python",
    16 => "Java",
    32 => "Rust",
    64 => "Go",
    128 => "Ruby",
    256 => "PHP",
    512 => "JavaScript",
    1024 => "TypeScript",
    2048 => "HTML/CSS",
    4096 => "Swift",
    8192 => "Objective-C",
    16384 => "Kotlin",
    32768 => "R",
    65536 => "SQL"
  }.freeze
  
  def calculate_select_pl(select_pl)
    s_pl = []
    PROGRAMMING_LANGUAGES.each do |key,val|
      if (select_pl & key) != 0
        s_pl.push(val)
      end
    end
    return s_pl
  end
  
  # プロフィール写真
  has_one_attached :profile_image
  
  def get_profile_image
    (profile_image.attatched?) ? profile_image : 'no_image.png'
  end
end
