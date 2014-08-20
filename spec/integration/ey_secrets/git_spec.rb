require 'spec_helper'
require 'fileutils'

module EySecrets
  describe Git do
    describe '.repository' do
      include FileUtils

      describe '.remotes' do
        it 'returns repository uris' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')

            remotes = Git.repository('repo').remotes

            expect(remotes).to eq([File.expand_path('origin_repo')])
          end
        end
      end

      describe '.files' do
        it 'returns paths relative to CWD' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file', 'some/file'])
            clone_repo('origin_repo', 'repo')

            files = Git.repository('repo').files

            expect(files.sort).to eq(['repo/file', 'repo/some', 'repo/some/file'])
          end
        end

        it 'removes leading dot' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')

            files = Dir.chdir('repo') do
              Git.repository('.').files
            end

            expect(files).to eq(['file'])
          end
        end
      end

      describe '.ready_for_update?' do
        it 'is true after clone' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')

            repository = Git.repository('repo')

            expect(repository).to be_ready_for_update
          end
        end

        it 'is false if repo has untracked files' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')
            `touch repo/other`

            repository = Git.repository('repo')

            expect(repository).not_to be_ready_for_update
          end
        end

        it 'is false if repo has modified files' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')
            `echo "change" > repo/file`

            repository = Git.repository('repo')

            expect(repository).not_to be_ready_for_update
          end
        end

        it 'is false if repo has unpushed commits' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')
            `(cd repo; echo "change" > file; git add .; git commit -m "change")`

            repository = Git.repository('repo')

            expect(repository).not_to be_ready_for_update
          end
        end

        it 'is true if all commits have been pushed' do
          in_sandbox do
            create_bare_repo('origin_repo', ['file'])
            clone_repo('origin_repo', 'repo')
            `(cd repo; echo "change" > file; git add .; git commit -m "change"; git push origin master 2> /dev/null)`

            repository = Git.repository('repo')

            expect(repository).to be_ready_for_update
          end
        end
      end


      def clone_repo(from, to)
        `git clone #{from} #{to} 2> /dev/null`
        Dir.chdir(to) { configure_git_user }
      end

      def create_bare_repo(name, files = {})
        mkdir('original_repo')
        Dir.chdir('original_repo') do
          `git init`
          configure_git_user
          files.each do |file|
            mkdir_p(File.dirname(file))
            touch(file)
          end
          `git add .; git commit -m "initial commit"`
        end
        `git clone --bare original_repo #{name} 2> /dev/null`
      end

      def configure_git_user
        `git config user.email spec@example.com`
        `git config user.name "EySecrets Spec"`
      end

      def in_sandbox(&block)
        rm_rf(sandbox_path)
        mkdir_p(sandbox_path)
        Dir.chdir(sandbox_path, &block)
      end

      def sandbox_path
        File.join(PROJECT_ROOT, 'spec', 'tmp')
      end
    end
  end
end
