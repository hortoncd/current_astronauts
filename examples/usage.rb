#!/usr/bin/env ruby

require 'current_astronauts'
include CurrentAstronauts

a = Astronauts.new
a.fetch
if a.success?
  puts "a is an instance of an #{a.class} class."
  puts
  puts "a.data is a #{a.data.class}."
  puts

  puts "a.num tells you how many astronauts are currently in space (#{a.num})."
  puts

  # use the list of people and craft as hash
  people = a.people
  first = a.people.first

  puts "a.people returns a list of people and their associated craft as an #{people.class} of type #{first.class}."
  puts
  puts "#{first['name']} is currently on: #{first['craft']}."
  puts

  # print out a list of people and craft
  puts "a.print prints out a formatted list of astronautes and their associated craft."
  a.print
else
  puts "Failed to fetch list of astronauts"
end
