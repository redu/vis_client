require 'representable/json'

module VisClient
  module NotificationRepresenter
    include Representable::JSON

    property :user_id
    property :type
    property :lecture_id
    property :subject_id
    property :space_id
    property :course_id
    property :status_id
    property :statusable_id
    property :statusable_type
    property :in_response_to_id
    property :in_response_to_type
    property :created_at
    property :updated_at

  end
end
