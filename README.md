# simple_git

High-level git wrapper for rb-libgit2

## Example

```ruby
require 'simple_git'

repo = SimpleGit::Repository.new('/path/to/git/repo')
walk = SimpleGit::Revwalk.new(repo)

puts "Current HEAD: #{repo.revparse('HEAD')}\n"

walk.sort(:GIT_SORT_TOPOLOGICAL)
walk.push_head

puts 'Last 25 commits:\n'

walk.take(25).each do |c|
  next if c.parent_count != 1

  stat = c.diff(c.parent(0)).stats

  puts "Commit #{c.oid[0..7]} by #{c.author.name} #{c.author.email} (+#{stat.insertions}/-#{stat.deletions}):"
  puts "    #{c.message}"
end
```
