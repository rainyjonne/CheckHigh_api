# frozen_string_literal: true
require_relative '../policies/course_policy'

module CheckHigh
  # Create new assignments for a share board
  class CreateAssiForCourse
    # Error for owner cannot be course's editor
    class ForbiddenError < StandardError
      def message
        'You are not allowed to add more assignments'
      end
    end

    # Error for requests with illegal attributes
    class IllegalRequestError < StandardError
      def message
        'Cannot create a assignment with those attributes'
      end
    end

    def self.call(auth:, course:, assignment_data:)
      policy = CoursePolicy.new(auth[:account], course, auth[:scope])
      raise ForbiddenError unless policy.can_add_assignments?

      course.add_assignment(assignment_data)
    rescue Sequel::MassAssignmentRestriction
      raise IllegalRequestError
    end
  end
end