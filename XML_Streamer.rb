#!/usr/bin/env ruby

require 'rexml/document'
require 'rexml/streamlistener'
include REXML

class Listener
  include StreamListener

  def initialize(args = nil)
    @current = {}
    @i = 1
  end

  def tag_start(name, attributes)
    if name == "POST" then
      @current = {}
      @node = @current
    else
      @current[name] = {}
      @node = @current[name]
      @tag = name
    end
    unless attributes.nil? then
      attributes.each do |k, v|
        @node[k] = v
      end
    end
  end

  def text(str = nil)
    unless str.nil? || "" == str.strip then
      @current[@tag] = str
    end
  end

  def tag_end(name)
    if name == "POST" then
      if nil != @current["___SPECIAL_TAG___"] then
        puts @current
      end
      STDERR.puts "I have parsed #{@i} posts"
      @i += 1
    end
  end
end

listener = Listener.new
parser = Parsers::StreamParser.new(File.new(ARGV[0]), listener)
parser.parse
