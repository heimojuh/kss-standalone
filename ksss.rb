#!/usr/bin/env ruby
require 'rubygems'
require 'kss'
require 'erb'

@cssdir = ARGV.shift()
@template = '';
@output = '';
@example_html;
@styleguide_block = '';

@styles = Kss::Parser.new(@cssdir)

File.open('templates/styleguide.html').each {
    |line| @template << line
}

File.open('templates/_styleguide_block.html').each {
    |line| @styleguide_block << line
}
extend ERB::DefMethod
def styleguide_block(section, &block)
    @section = @styles.section(section)
    puts block.call
#    @example_html = capture{ block.call }
    @example_html = block.call
    @output << ERB.new(@styleguide_block,0).result();
end

def capture(&block)
    out, @_out_buf = @_out_buf, ""
    yield
    @_out_buf
ensure
    @_out_buf = out
end



if ARGV.length
    ARGV.each do |sec|
        @section = @styles.section(sec)
        @output << ERB.new(@template, 0).result();
    end 
end


File.open('cssdocs.html', 'w+') {
    |f| f.write(@output)
}
