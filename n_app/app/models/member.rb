class Member < ApplicationRecord

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリテーションの設定
  validates :student_id, presence: true, format: { with: /\A[a-zA-Z]{2}\d{4,}\z/ }
  validates :name, presence: true
  validates :password, presence: true, length: { within: 8..128 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\W_]).{8,}\z/, message: "must be at least 8 characters and include at least one letter, one number, and one special character" }, if: :password_required?

  has_many :activities, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, :through => :team_members

  enum member_role: { user: 0, mod: 1, admin: 2 }
  enum grade: { freshman: 0, sophomore: 1, junior: 2, senior: 3, graduate: 4 }

  DEPARTMENT_COURSES = {
    information_technology: [:ai_strategy, :iot_systems, :robotics_development],
    digital_entertainment: [:game_production, :cg_animation]
  }.freeze

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
    2048 => "HTML",
    4096 => "CSS",
    8192 => "Swift",
    16384 => "Kotlin",
    32768 => "R",
    65536 => "SQL",
  }.freeze

  FRAMEWORKS = {
    2 => "Ruby on Rails",
    4 => "Vue.js",
    8 => "Flask",
    16 => "CakePHP",
    32 => "Laravel",
    64 => "Gin",
    128 => "SwiftUI"
  }.freeze

  LIBRARIES = {
    2 => "React",
    4 => "jQuery",
    8 => "Numpy",
    16 => "matplotlib"
  }.freeze

  GAME_ENGINES = {
    2 => "Unreal Engine",
    4 => "Unity",
    8 => "Godot",
    16 => "Construct 3",
    32 => "CryEngine",
    64 => "Defold"
  }.freeze

  GRAPHICS_3D = {
    2 => "Blender",
    4 => "Maya",
    8 => "Cinema"
  }.freeze

  ATTR_DICT = {
    0 => "Programming Languages",
    1 => "Framework",
    2 => "Library",
    3 => "Game Engine",
    4 => "3D Graphics"
  }.freeze

  def calculate_select_pl(select_pl)
    s_pl = []
    PROGRAMMING_LANGUAGES.each do |key, val|
      if (select_pl & key) != 0
        s_pl.push(val)
      end
    end
    s_pl
  end

  def calculate_selected_attr(selected_attr, hash_str)
    s_attr = []
    case hash_str
    when "PROGRAMMING_LANGUAGES"
      hash = PROGRAMMING_LANGUAGES
    when "FRAMEWORKS"
      hash = FRAMEWORKS
    when "LIBRARIES"
      hash = LIBRARIES
    when "GAME_ENGINES"
      hash = GAME_ENGINES
    else
      hash = GRAPHICS_3D
    end

    hash.each do |key, val|
      if (selected_attr & key) != 0
        s_attr.push(val)
      end
    end
    return s_attr
  end

  # プロフィール写真
  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.png'
  end
end
