class ViewCustomize < ActiveRecord::Base
  unloadable

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_presence_of :path_pattern
  validates_length_of :path_pattern, :maximum => 255

  validates_presence_of :code

  validate :valid_pattern

  TYPE_JAVASCRIPT = "javascript"
  TYPE_CSS = "css"

  @@customize_types = {
    :label_javascript => TYPE_JAVASCRIPT,
    :label_css => TYPE_CSS
  }

  INSERTION_POSITION_HTML_HEAD = "html_head"
  INSERTION_POSITION_ISSUE_FORM = "issue_form"
  INSERTION_POSITION_ISSUE_SHOW = "issue_show"

  @@insertion_positions = {
    :label_insertion_position_html_head => INSERTION_POSITION_HTML_HEAD,
    :label_insertion_position_issue_form => INSERTION_POSITION_ISSUE_FORM,
    :label_insertion_position_issue_show => INSERTION_POSITION_ISSUE_SHOW
  }

  def customize_types
    @@customize_types
  end

  def customize_type_label
    @@customize_types.key(customize_type)
  end

  def insertion_positions
    @@insertion_positions
  end

  def insertion_position_label
    @@insertion_positions.key(insertion_position)
  end

  def is_javascript?
    customize_type == TYPE_JAVASCRIPT
  end

  def is_css?
    customize_type == TYPE_CSS
  end

  def available?(user=User.current)
    is_enabled && (!is_private || author == user)
  end

  def valid_pattern
    begin
      Regexp.compile(path_pattern)
    rescue
      errors.add(:path_pattern, :invalid)
    end
  end

  def initialize(attributes=nil, *args)
    super
    if new_record?
      self.author = User.current
    end
  end
  
end
