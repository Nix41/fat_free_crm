# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'roo'

module FatFreeCRM
  class ImportHandle
    class << self
      def get_columns(path)
        headers = Hash.new

        puts path

=begin
        xlsx = Roo::Spreadsheet.open(path)
        sheet = xlsx.sheets.first

        puts sheet.row(1)

        sheet.row(1).each_with_index { |header, i|
          headers[i] = header
        }
=end

        return headers

      end
      def process(importer)
        result = {
            items: [],
            errors: []
        }
        xlsx = Roo::Spreadsheet.open(importer.attachment.path)

        xlsx.each_with_pagename do |name, sheet|
          headers = Hash.new
          sheet.row(1).each_with_index { |header, i|
            headers[header] = i
          }
          ((sheet.first_row + 1)..sheet.last_row).each do |row|
            item = nil
            if importer.entity_type == 'Campaign'
              item = Campaign.import_from_xls(sheet.row(row), headers)
            elsif importer.entity_type == 'Lead'
              item = Lead.import_from_xls(sheet.row(row), headers)
            end
            if item
              result[:items].push(item)
              if item.errors.count
                result[:errors].push(item.errors.full_messages)
              end
            end
          end
        end

        result
      end
    end
  end
end


