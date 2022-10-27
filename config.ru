require 'sinatra'
require 'pry-remote' if development?

require File.dirname(__FILE__) + '/app'

run App