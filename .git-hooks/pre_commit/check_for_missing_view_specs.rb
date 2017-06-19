module Overcommit
  module Hook
    module PreCommit
      # Class to remove stray focus: true inclusions
      class CheckForMissingViewSpecs < Base
        # Overcommit expects you to override this method which will be called
        # everytime your pre-commit hook is run.
        def run
          check_files

          return :fail, error_lines.join("\n") if error_lines.any?

          return :warn, "Check 'focus true' on lines you didn't modify\n" <<
            warning_lines.join("\n") if warning_lines.any?

          :pass
        end

        private

        def check_files
          rails_root=Dir.pwd.gsub(/\/.git-hooks\/pre_commit.*$/,'')
          view_path="#{rails_root}/app/views"
          spec_path="#{rails_root}/spec/views"
          check_path(view_path,spec_path)
        end

        def check_path(iv,is)
          d=Dir.new(iv)
          files=d.entries-['.','..','.DS_Store']
          if files.any?
            files.each do |f|
              v="#{iv}/#{f}"
              s="#{is}/#{f}"
              if File.directory?(v)
                if File.exists?(s) 
                  unless File.directory?(s)
                    error_lines_add("#{s} exists, but is not a directory like #{v}")
                  end
                else
                  FileUtils.mkdir(s, mode: 0755)
                end
                check_path(v,s)
              else
                spec_file_name="#{s}_spec.rb"
                unless File.exists?(spec_file_name)
                  error_lines_add("Had to create a missing view spec at #{spec_file_name}. Run your tests before re-committing, please.")
                  FileUtils.touch spec_file_name
                  FileUtils.chmod 0644,spec_file_name
                  open(spec_file_name, 'w') { |f|
                    f.puts here_doc(clipped_file_name(s)) 
                  }
                end
              end
            end
          end
        end

        def clipped_file_name(fn)
          fn.gsub(/^.*views\//,'')
        end

        def here_doc(fn)
          <<-END.gsub(/^ {12}/,'').gsub(/FILENAME/,fn)
            require 'rails_helper'

            RSpec.describe 'FILENAME', type: :view do
              setup_factories

              before do
              end

              it 'should render without error' do
                render
              end
            end
          END
        end

        def error_lines
          @error_lines ||= []
        end

        def error_lines_add(message)
          error_lines << message
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
