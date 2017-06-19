module Overcommit
  module Hook
    module PreCommit
      # Class to remove stray focus: true inclusions
      class RemoveFocusTrue < Base
        # Overcommit expects you to override this method which will be called
        # everytime your pre-commit hook is run.
        def run
          # The `config` attribute is a hash of
          # your settings based on your `.overcommit.yml` file.
          # max_line_length = config['max']

          check_files

          # Overcommit expects 1 of the 3 as return values,
          # `:fail`, `:warn` or `:pass`.
          # If the hook returns `:fail`, the commit will
          # be aborted with our message containing the errors.
          return :fail, error_lines.join("\n") if error_lines.any?

          # If the hook returns `:warn`, the commit will
          # continue with our message containing the warnings.
          return :warn, "Check 'focus true' on lines you didn't modify\n" <<
            warning_lines.join("\n") if warning_lines.any?

          :pass
        end

        def check_file(file)
          # `modified_lines` is another method provided by Overcommit. It will
          # return an array containing the index of lines in the file which have
          # been modified for the particular commit.
          # modified_lines_num = modified_lines(file)

          # Loop through each file with the index.
          File.open(file, 'r').each_with_index do |line, index|
            # Check if the line contains focus true.
            next unless line.match(/:focus\s*?=>\s*?true|focus:\s*?true/)
            message = "#{file}:#{index + 1}: #{focus_true_message}"
            error_lines_add(message)
          end
        end

        def check_files
          # For pre-commit hooks, `applicable_files` is one of the methods that
          # Overcommit provides which returns an array of files that have been
          # modified for the particular commit.

          applicable_files.each do |file|
            check_file(file)
          end
        end

        def error_lines
          @error_lines ||= []
        end

        def error_lines_add(message)
          error_lines << message
        end

        def focus_true_message
          'Line contains "focus true". Remove it before commit, please'
        end

        def warning_lines
          @warning_lines ||= []
        end

        def warning_lines_add(message)
          warning_lines << message
        end
      end
    end
  end
end
