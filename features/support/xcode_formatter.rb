# features/support/xcode_formatter.rb
require 'rubygems'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'gherkin/formatter/escaping'

module Cucumber
    module Formatter
        class Xcode

            include Console
            include Io
            include Gherkin::Formatter::Escaping
            attr_writer :indent
            attr_reader :runtime

            def initialize(runtime, path_or_io, options)

                @io = ensure_io(path_or_io, "pretty")
                @indent = 0
                @delayed_messages = []
                @has_examples = false

            end

            def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)

                print_method_name("after_step_result")

                return if status == :passed

                if exception != nil
                    msg = exception.message + ' # ' + step_match.file_colon_line
                else
                    msg = format_step(keyword, step_match, status, 0) + " (#{status})"
                end

                if status == :failed
                    type = "error"
                else
                    type = "warning"
                end

                # one error for the feature file

                format_for_xcode(file_colon_line, type, msg)

                # one error for the step_definitions, but only if exception

                if exception != nil

                    format_for_xcode('features/step_definitions/' + step_match.file_colon_line, type, format_step(keyword, step_match, status, nil) + ', ' + exception.message)

                end


            end

            def before_feature_element(element)

                print_method_name("before_feature_element")

            end

            def after_feature_element(element)

                print_method_name("after_feature_element")

                if !@has_examples
                    print_messages
                end
                @has_examples = false

            end

            def before_examples(examples)

                print_method_name("before_examples")

                @has_examples = true

            end

            def after_examples(examples)

                print_method_name("after_examples")

            end

            def before_table_row(table_row)

                print_method_name("before_table_row")

            end

            def after_table_row(table_row)

                print_method_name("after_table_row")

                if table_row.exception

                    # one error at the example row

                    file_colon_line = table_row.backtrace_line[/^(.*:\d+:)/,1]

                    format_for_xcode(file_colon_line, "error", format_exception(table_row.exception))

                    # one error at the outline row

                    file_colon_line = table_row.exception.backtrace.join('')[/^(.*:\d+:)/,1]

                    format_for_xcode(file_colon_line, "error", format_exception(table_row.exception))

                    print_messages

                    # unfortunately, can't record error for the location in
                    # the step_definitions

                end

            end



            def respond_to?(*args)
                true
            end

            def method_missing(name, *args)

                print_method_name(name)

            end



            private

            def format_exception(e)

                "#{e.message}. #{e.backtrace.join("\n")} (#{e.class})"

            end

            def print_method_name(name)
return
                case (name)
                    when /^before/
                    @indent += 1
                end

                print(name)

                case (name)
                    when /^after/
                    @indent -= 1
                end

            end

            def print(text)
                @io.puts "#{@indent} #{text}".indent(@indent)
            end

            def format_for_xcode(file_colon_line, type, message)

                puts(file_colon_line + ': ' + type + ': ' + message)

            end

        end

    end

end





