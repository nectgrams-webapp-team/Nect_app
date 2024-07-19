class Member < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  # バリテーションの設定
  validates :student_id, presence: true, format: { with: /\A[a-zA-Z]{2}\d{4,}\z/ }
  validates :name, presence: true

  has_many :activities, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, :through => :team_members

  def calculate_graduation_year(student_id)
    if student_id == nil 
      return 0
    end
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
    1 => "Ruby",
    2 => "C",
    4 => "C#",
    8 => "C++",
    16 => "Python",
    32 => "Java",
    64 => "Go",
    128 => "PHP",
    256 => "JavaScript",
    512 => "R",
    1024 => "HTML/CSS",
    2048 => "Swift",
    4096 => "Kotlin",
    8192 => "Rust",
    16384 => "Objective-C",
    32768 => "TypeScript",
    65536 => "SQL"
  }.freeze
  
  def calculate_select_pl(select_pl)
    s_pl = []
    PROGRAMMING_LANGUAGES.each do |key,val|
      if (select_pl & key) != 0
        s_pl.push(val)
      end
    end
    s_pl.join(" , ")
  end
  
  # プロフィール写真
  has_one_attached :profile_image
  
  def get_profile_image
    (profile_image.attatched?) ? profile_image : 'no_image.png'
  end
  
  enum :grade, { '1年生': '1', '2年生': '2', '3年生': '3', '4年生': '4', 'OM': '5' }
  enum :department, { "情報工学科": 1, "デジタルエンタテインメント学科": 2 }
  enum :member_role, { user: 0, mod: 1, admin: 2 }
end
