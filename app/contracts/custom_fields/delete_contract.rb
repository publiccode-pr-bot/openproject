# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module CustomFields
  class DeleteContract < BaseContract
    validate :not_referenced

    def not_referenced
      referencing = model.class.with_formula_referencing(model)
      return if referencing.empty?

      errors.add(:base, :referenced_in_other_fields, message: referenced_html_error_message(referencing))
    end

    private

    def referenced_html_error_message(referencing)
      links = referencing.map do |cf|
        url = url_helpers.admin_settings_project_custom_field_path(cf)
        helpers.link_to(cf.name, url)
      end

      helpers.t(
        "activerecord.errors.models.custom_field.referenced_in_other_fields.html",
        name: model.name,
        links: helpers.to_sentence(links)
      )
    end

    def helpers = ActionController::Base.helpers

    def url_helpers = Rails.application.routes.url_helpers
  end
end
