# Copyright (c) 2012 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'relaxo/database'

require 'etc'

module Relaxo
	MASTER = 'master'.freeze
	
	def self.connect(path, branch: nil, sync: nil, **metadata)
		unless File.exist?(path)
			repository = Rugged::Repository.init_at(path, true)
			
			if sync || ENV['RELAXO_SYNC']
				repository.config['core.fsyncObjectFiles'] = true
			end
		end
		
		branch ||= MASTER
		
		database = Database.new(path, branch, metadata)
		
		if config = database.config
			unless config['user.name']
				config['user.email'] = config['user.name'] = Etc.getlogin
			end
		end
		
		return database
	end
end