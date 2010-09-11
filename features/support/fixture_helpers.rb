module FixtureHelpers
  FIXTURE_DIR = File.join(File.dirname(__FILE__), '..', 'fixtures')

  def fixture_file(file)
    file = File.join(FIXTURE_DIR, file)

    if File.exists?(file)
      FixtureFile.new(file)
    else
      raise "Can't find fixture #{file}"
    end
  end

  class FixtureFile
    def initialize(file)
      @file = file
    end

    def data
      File.read(@file)
    end

    def type
      extension = @file.split('.').last
      case extension
        when 'json'
          'application/json'
        else
          raise "Can't determine type for extension '#{extension}'"
      end
    end
  end
end
