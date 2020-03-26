# Bonus file, courtesy from Tom Ward from Basecamp
# Forked from https://gist.github.com/tomafro/054d7d1a7c40ade27405599289196a54

module Suppressible
  def self.extended(base)
    base.thread_mattr_accessor :suppressed, instance_accessor: false
    base.delegate :suppressed?, to: 'self.class'
  end

  def suppress(&block)
    original, self.suppressed = self.suppressed, true
    yield
  ensure
    self.suppressed = original
  end

  def suppressed?
    suppressed
  end
end
