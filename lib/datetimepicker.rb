# Calendar

require "date"

module ActionView
  module Helpers
    module FormTagHelper
      def datetime_select_tag(name, value = nil, options = {}, html_options = {})
        curr_value = value ? value.to_datetime : Time.now
        html_options[:id] ||= name
        html_options[:name] ||= name
        DateTimeSelector.new(curr_value, options, html_options).select_datetime
      end

      def date_select_tag(name, value = nil, options = {}, html_options = {})
        curr_value = value ? value.to_date : Date.today
        html_options[:id] ||= name
        html_options[:name] ||= name
        DateTimeSelector.new(curr_value, options, html_options).select_date
      end
    end

    class DateTimeSelector #:nodoc:
      def select_datetime
        @options = parse_time_format @options
        build_html_options
        build_calendar
      end

      def select_date
        @options[:format]  ||= "%m/%d/%Y"
        @options = parse_date_format @options
        build_html_options
        build_calendar
      end

      private

        def build_html_options
          if (@html_options[:name].blank?)
            @html_options[:name] = "#{@options[:prefix]}[#{@options[:field_name]}]"
          end
          if(@html_options[:id].blank?)
            @html_options[:id] = "#{@options[:prefix]}_#{@options[:field_name]}"
          end
        end

        def self.options_to_remove
          [ :name, :class, :id, :object_name, :method, :datetime_separator, :include_position, :tag, :style, :prefix, :field_name, :time_separator, :default, :value, :format ]
        end

        def build_calendar
          html  = ""
          date_value = @datetime.strftime(@options[:format])
          html << tag(:input, { "type" => "text", "name" => @html_options[:name], "id" => @html_options[:id], "value" => date_value }.update(@html_options.stringify_keys))
          unless @html_options[:readonly]
            calendar_options = Hash.new
            calendar_options.replace(@options)
            calendar_options.delete_if { | key, value |
              self.class.options_to_remove.include? key
            }
            html << %(<script type="text/javascript">\n)
            if @options[:showTime].blank?
              html << %( $\('##{@html_options[:id]}'\).datepicker\({\n )
            else
              html << %( $\('##{@html_options[:id]}'\).datetimepicker\({\n )
            end
            calendar_options.sort
            t_options = calendar_options.map {|o| o[1].instance_of?(String) ? "#{o[0]} : '#{o[1]}'" : "#{o[0]} : #{o[1]}"}
            html << t_options.join(", ")
            html << %(    }\);\n)
            html << %(</script>\n)
          end
          html
        end

        def parse_format(fmt) 
          fmt.gsub(/%([-_0^#]+)?(\d+)?([EO]?(?::{1,3}z|.))/m) do |m|
            a = $&
            case a
            when '%A'; "DD"
            when '%a'; "D"
            when '%B'; "MM"
            when '%b'; "M"
            when '%d'; "dd"
            when '%e'; "d"
            when '%H'; "hh"
            when '%h'; "M"
            when '%I'; "hh"
            when '%j'; "oo"
            when '%k'; "h"
            when '%l'; "h"
            when '%M'; "mm"
            when '%m'; "mm"
            when '%P', "%p"; "TT"
            when '%S', '%OS'; "ss"
            when '%Y', '%EY', '%04Y'; "yy"
            when '%y', '%Ey', '%Oy'; "y"
            when '%Z', '%z'; ""
            else
              a
            end
          end # fmt.gsub.. do
        end

        def extract_time_format(fmt)
          positions = []
          fmt.scan(/%[HkIlMSpZz]/) {|m|positions << fmt.index(m) }
          unless positions.empty?
            positions.sort!
            time_format = fmt[positions.first, (positions.last-positions.first+2)]
            date_format = fmt.gsub(time_format, "").strip
            ampm = time_format.match(/%[Il]/) ? true : false
          else
            time_format = nil
            date_format = fmt
            ampm = false
          end
          return date_format, time_format, ampm
        end

        def parse_date_format(options)
          options[:format] ||= "%m/%d/%Y"
          date_format = extract_time_format(options[:format])
          options[:dateFormat] = parse_format(date_format[0])
          options.delete(:showTime) unless options[:showTime].nil?
          options
        end

        def parse_time_format(options)
          options[:format] ||= "%m/%d/%Y %I:%M %p"
          options[:showTime] = true
          date_format, time_format, options[:ampm] = extract_time_format(options[:format])
          options[:dateFormat] = parse_format(date_format)
          if time_format.blank?
            options[:timeFormat] = nil
          else
            options[:timeFormat] = parse_format(time_format)
          end
          options
        end

    end

  end
end