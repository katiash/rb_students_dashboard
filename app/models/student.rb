class Student < ActiveRecord::Base
  # EMAIL_REGEX = / \A ([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+) \z /i
  EMAIL_REGEX = /.+@.+\..+/i
  belongs_to :dojo
  validates :first_name, :last_name, presence: true,  length: {minimum: 2}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: EMAIL_REGEX}
  # or :format => /EMAIL_REGEX_GOES_HERE/

# def self.with_dojo student_id
#   self.joins(:dojo).where("students.id = ?", student_id).select(:id, :first_name, :last_name, :email, :branch, :dojo_id, :created_at).first
# end

def self.cohort(student)
  self.where("id != ? AND dojo_id = ? AND DATE(created_at) = ?", student.id, student.dojo_id, student.created_at.strftime("%Y-%m-%d"))
end

end