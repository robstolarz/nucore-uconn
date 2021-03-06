module NavTab

  extend ActiveSupport::Concern

  included do
    class_attribute :customer_actions
    class_attribute :admin_actions

    helper_method(:customer_tab?)
    helper_method(:admin_tab?)
    helper_method(:global_navigation_links)
    helper_method(:navigation_links)
  end

  module ClassMethods

    # Specifies that the named actions should show the customer tabs (which is enforced by set_tab).
    def customer_tab(*actions)
      self.customer_actions = actions
    end

    # Specifies that the named actions should show the admin tabs (which is enforced by set_tab).
    def admin_tab(*actions)
      self.admin_actions = actions
    end

  end

  # Returns true if the current action is an admin tab action
  def admin_tab?
    ((self.class.admin_actions || []) & [action_name.to_sym, :all]).any?
  end

  def navigation_links
    case
    when customer_tab? && acting_user.present?
      link_collection.customer.compact
    when admin_tab? && current_facility.present? && current_facility != Facility.cross_facility
      link_collection.admin
    else
      link_collection.default
    end
  end

  def global_navigation_links
    acting_as? ? [] : global_link_collection.links
  end

  protected

  # Returns true if the current action is a customer tab action
  def customer_tab?
    ((self.class.customer_actions || []) & [action_name.to_sym, :all]).any?
  end

  private

  def global_link_collection
    @global_link_collection ||= NavTab::GlobalLinkCollection.new(current_ability)
  end

  def link_collection
    @link_collection ||= LinkCollection.new(current_facility, current_ability)
  end

end
