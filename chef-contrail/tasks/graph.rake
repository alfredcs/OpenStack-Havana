def find_deps(cookbook_dir)
  nel = Hash.new { |h, k| h[k] = [] }
  Dir.glob("#{cookbook_dir}/*/").each do |r|
    deps_for(r, nel)
  end
  nel
end

def deps_for(dir, nel)
  regex = /.*include_recipe +("|')([^"]+)("|')/
  dir = dir.sub(/\/$/, "")
  Dir.glob("#{dir}/recipes/*.rb").each do |recipe|
    deps = []
    r_name = File.basename(recipe).sub(/\.rb$/, "")
    item = File.basename(dir) + "::" + r_name
    open(recipe) do |f|
      f.each do |line|
        m = line.match(regex)
        if m
          if !m[2].match(/::/)
            deps << (m[2] + "::default")
          else
            deps << m[2]
          end
        end
      end
    end
    nel[item] = deps
  end
end

def to_dot(nel, name)
  dot = "digraph #{name} {"
  nel.each do |n, deps|
    deps.each do |d|
      dot << "    \"#{n}\" -> \"#{d}\";"
    end
  end
  dot << "}"
end

desc "produce a dependency graph with graphviz"
task :graph do
  File.open("cookbooks.dot", "w") do |f|
    f.write to_dot(find_deps('cookbooks'), 'cookbook')
  end
  sh "dot -Tsvg -ocookbooks.svg cookbooks.dot"
end
