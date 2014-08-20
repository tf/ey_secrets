module EySecrets
  class Git < Struct.new(:path)
    def self.repository(path)
      new(path).repository
    end

    def repository
      Repository.new(remotes, files, in_sync?)
    end

    private

    def remotes
      Dir.chdir(path) do
        @remotes ||= `git remote -v`.scan(/\t[^\s]+\s/).map { |c| c.strip }.uniq
      end
    end

    def files
      Dir[File.join(path, '**', '*')].map do |file|
        file.gsub(%r'^\./', '')
      end
    end

    def in_sync?
      in_sync_with_origin? && clean?
    end

    def in_sync_with_origin?
      git_revision_diff_count == 0
    end

    def clean?
      Dir.chdir(path) do
        `git status --porcelain` == ''
      end
    end

    def git_revision_diff_count
      Dir.chdir(path) do
        `git fetch && git rev-list HEAD..origin/master --count`.to_i +
          `git rev-list origin/master..HEAD --count`.to_i
      end
    end
  end
end
