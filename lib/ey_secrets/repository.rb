module EySecrets
  class Repository
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def exists?
      File.exists?(File.join(path, '.git'))
    end

    def clone(uri)
      `git clone #{uri} #{path}`
    end

    def pull
      Dir.chdir(path) do
        `git pull origin master`
      end
    end

    def commit
      Dir.chdir(path) do
        `git commit -a`
      end
    end

    def push
      Dir.chdir(path) do
        `git push origin master`
      end
    end


    def glob(pattern)
      Dir[File.join(path, pattern)]
    end

    def assert_clean!
      if !clean? || !in_sync_with_origin?
        raise "Please, commit and push your changes before updating config."
      end
    end

    def in_sync_with_origin?
      git_revision_diff_count == 0
    end

    def clean?
      Dir.chdir(path) do
        `git status --porcelain` == ''
      end
    end

    def remotes
      Dir.chdir(path) do
        @remotes ||= `git remote -v`.scan(/\t[^\s]+\s/).map { |c| c.strip }.uniq
      end
    end

    private

    def git_revision_diff_count
      Dir.chdir(path) do
        `git fetch && git rev-list HEAD..origin/master --count`.to_i +
          `git rev-list origin/master..HEAD --count`.to_i
      end
    end
  end
end
