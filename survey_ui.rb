require 'active_record'

require './lib/survey'
require './lib/question'
require './lib/answer'
require 'pry'


database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  clear
  puts "================================================"
  puts "\e[4;34mWelcome to our fun survey generator!\e[0;0m\n"
  puts " Press 's' if you are a Survey Designer"
  puts "       't' if you are a Survey Taker.\n"
  choice = gets.chomp
  if choice == 's'
    designer_menu
  elsif choice == 't'
    survey_menu
  else
    clear
    error
    welcome
  end
end

def designer_menu
  clear
  puts "=== DESIGNER MENU ==="
  puts " Press 's' to go to the survey options menu"
  puts " Press 'q' to go to the question options menu"
  choice = gets.chomp
  if choice == 's'
    survey_options
  elsif choice == 'q'
    question_options
  else
    clear
    error
    designer_menu
  end
end

def survey_options
  clear
  puts "=== SURVEY OPTIONS ==="
  puts " Press 's' to make a new survey"
  puts "       'l' to list surveys"
  puts "       'e' to edit a survey"
  puts "       'd' to delete a survey"
  puts "       'm' to go back to designer menu"
  case gets.chomp
  when 's'
    add_survey
  when 'l'
    list_surveys
    designer_menu
  when 'e'
    list_surveys
    edit_survey
  when 'd'
    delete_survey
  when 'a'
    add_questions
  when 'm'
    designer_menu
  else
    clear
    error
    survey_options
  end
end

def question_options
  clear
  puts "=== QUESTION OPTIONS ==="
  puts " Press 'a' to add a new question"
  puts "       'l' to list questions"
  puts "       'e' to edit a question"
  puts "       'd' to delete a question"
  puts "       'm' to go back to designer menu"
  case gets.chomp
  when 'a'
    add_questions
  when 'l'
    list_questions
    designer_menu
  when 'e'
    list_surveys
    edit_question
  when 'd'
    delete_question
  when 'm'
    designer_menu
  else
    clear
    error
    question_options
  end
end

##--------SURVEY MENU--------##

def add_survey
  clear
  puts "Enter the name of your new survey."
  new_survey_name = gets.chomp
  new_survey = Survey.create({survey_title: new_survey_name})
  clear
  puts "#{new_survey.survey_title} has been added"
  designer_menu
end

def list_surveys
  clear
  puts "======================"
  Survey.all.each do |survey|
    puts "#{survey.survey_title}"
  end
  puts "======================"
end

def edit_survey
  puts "Enter the title of the survey you would like to edit"
  name_survey = gets.chomp
  edit_survey = Survey.where({survey_title: name_survey}).first

  puts "Enter the new title"
  new_title = gets.chomp
  edit_survey.update({survey_title: new_title})

  puts "#{new_title} has been updated to our database"
  designer_menu
end

def delete_survey
  list_surveys
  puts "Enter the title of the survey that you would like to delete."
  choice = gets.chomp
  delete_survey = Survey.where({survey_title: choice}).first
  delete_survey.destroy

  puts "#{choice} has been deleted from our database"
  designer_menu
end


##--------QUESTIONS MENU--------##

def add_questions
  list_surveys
  puts "Enter the title of the survey you would like to add questions to."
  survey = gets.chomp
  chosen_survey = Survey.where({survey_title: survey}).first

  puts "Please enter a question."
  new_question = gets.chomp
  # binding.pry
  Question.create({question: new_question, survey_id: chosen_survey.id})
  puts "#{new_question} has been added to the #{survey}"
  puts "Would you like to add more questions? Y or N?"
  choice = gets.chomp.downcase
  if choice == 'y'
    add_questions
  elsif choice == 'n'
    question_options
  else
    clear
    error
    question_options
  end
 # chosen_survey.questions.new({question: new_question})
end

def list_questions
  clear
  puts "======================"
  Question.all.each do |x|
      x.question
      x.survey_id
      survey_name = Survey.find(x.survey_id)
    puts "#{x.question} survey:#{survey_name.survey_title}"
  end
  puts "======================"
end

#~~~~~~~~OTHERS~~~~~#

def clear
  system "clear"
end

def error
  puts "\e[5;31mERROR!!!"
  puts "(ಠ_ಠ) \e[0;0m"
end

def exit
  puts "\e[5;32m"
  clear
  sleep(1)
  puts "¸.·´¯`·"
  sleep(1)
  clear
  puts ".´¯`·.¸¸.·´¯`·."
  sleep(1)
  clear
  puts ".´¯`·.¸¸.·´¯`·..´¯`·.¸¸¸"
  sleep(1)
  clear
  puts ".´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸¸><(((º> Good-bye\e[0;0m"
end

welcome
