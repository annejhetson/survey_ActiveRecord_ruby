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
  puts "=== DESIGNER MENU ==="
  puts " Press 's' to go to the survey options"
  puts " Press 'q' to go to the question options"
  puts " Press 'a' to go to the answer options"
  choice = gets.chomp
  if choice == 's'
    survey_options
  elsif choice == 'q'
    question_options
  elsif choice == 'a'
    answer_options
  else
    clear
    error
    designer_menu
  end
end

def survey_options
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
    survey_options
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
    question_options
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

##-------SURVEY TAKER MENU------##
def survey_menu
  list_surveys
  puts "Select one of the surveys you would like to take"
  user_survey = gets.chomp

  that_survey = Survey.where({survey_title: user_survey}).first
  that_survey.questions.each do |qs|
    puts "#{qs.question}"
    answer = gets.chomp
    qs.answers.create({answer: answer})    
  end
  puts "\e[3;33mThank you for participating in our survey!"
  puts "---------------GOOD_BYE------------------\e[0;0m"
end

##--------SURVEY OPTIONS--------##

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


##--------QUESTION OPTIONS--------##

def add_questions
  list_surveys
  puts "Enter the title of the survey you would like to add questions to."
  survey = gets.chomp
  chosen_survey = Survey.where({survey_title: survey}).first

  puts "\nPlease enter a question."
  new_question = gets.chomp
  chosen_survey.questions.create({question: new_question})
  binding.pry
  puts "'#{chosen_survey.questions[-1].question}' has been added to the #{chosen_survey.survey_title}\n"
  puts "Would you like to add more questions? Y or N?"
  choice = gets.chomp.downcase
  if choice == 'y'
    clear
    add_questions
  elsif choice == 'n'
    clear
    question_options
  else
    clear
    error
    question_options
  end
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

def delete_question
  clear
  Question.all.each_with_index do |x, index|
    puts "#{index + 1}) #{x.question}"
  end

  puts "Enter the number of the one you would you like to delete."
  number = gets.chomp.to_i
  name = Question.all[number - 1].question
  Question.all[number - 1].destroy
  puts "#{name} has been deleted!!"
  question_options
end

def edit_question
  clear
  Question.all.each_with_index do |x, index|
    puts "#{index + 1}) #{x.question}"
  end

  puts "Enter the number of the question you would like to edit."
  number = gets.chomp.to_i
  question = Question.all[number - 1]
  old_question = question.question
  puts "Please enter the new question"
  new_question_text = gets.chomp

  list_surveys
  puts "\n What survey does the question go with?"
  new_survey_name = gets.chomp
  survey_object = Survey.where({survey_title: new_survey_name}).first
  question.update({question: new_question_text, survey_id: survey_object.id})

  puts "#{old_question} has been changed"
  puts "again, the new question is #{question.question}"
  puts "in #{new_survey_name}"
  question_options
end

##--------ANSWER OPTIONS--------##

def answer_options
  list_surveys
  puts " Select the survey you would like to see the answer\n"
  the_survey = gets.chomp
  the_survey = Survey.where({survey_title: the_survey}).first
  the_survey.questions.each_with_index { |qs, index| puts "#{index +1}) #{qs.question}"}
  puts " Select question number to see all answers"
  number = gets.chomp.to_i
  if number == 0
    clear
    error
    sleep(2)
    answer_options
  else
    clear
    puts " ====SURVEY: #{the_survey.survey_title}===="
    puts " QUESTION: #{the_survey.questions[number-1].question}"
    puts " ANSWERS:"
    the_survey.questions[number-1].answers.each do |ans|
      puts "- #{ans.answer}"
    end
    designer_menu
  end
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
