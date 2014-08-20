require 'spec_helper'

module EySecrets
  describe Shell do
    describe '.execute!' do
      it 'runs commands of action' do
        action = Class.new do
          def commands
            ['echo "output"']
          end
        end.new

        expect {
          quietly do
            Shell.execute!(action)
          end
        }.not_to raise_error
      end

      it 'raises CommandFailed error if exit status is not 0' do
        action = Class.new do
          def commands
            ['false']
          end
        end.new

        expect {
          quietly do
            Shell.execute!(action)
          end
        }.to raise_error(Shell::CommandFailed)
      end

      def quietly(&block)
        silence_stream(STDOUT, &block)
      end

      def silence_stream(stream)
        old_stream = stream.dup
        stream.reopen('/dev/null')
        stream.sync = true
        yield
      ensure
        stream.reopen(old_stream)
        old_stream.close
      end
    end
  end
end
