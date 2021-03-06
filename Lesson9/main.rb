#!/usr/bin/ruby

require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'railwaystation'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'

menu =
  "
  1. Создавать станции
  2. Создавать поезда
  3. Добавлять вагоны к поезду
  4. Отцеплять вагоны от поезда
  5. Помещать поезда на станцию
  6. Просматривать список станций и список поездов на станции
  7. Вызывать Train.all
  8. Для каждой станции список поездов
  "

@trains_counter = 0
@stations = []

def create_station
  puts "Название:"
  name = gets.to_s
  station = RailwayStation.new(name) if name.length != 0

  return unless station

  @stations << station
  puts station
end

def create_train
  puts "Тип(#{Train::PASSENGER},#{Train::CARGO}):"
  type = gets.to_s
  puts "Длина:"
  length = gets.to_i
  train = Train.new(@trains_counter, type, length) if type.length != 0

  return unless train

  @trains_counter += 1
  puts train
end

def add_wagon
  return unless train

  w = ask_wagon

  train.add_wagon(w)
  puts train
end

def ask_wagon
  case wagon_type
  when 1
    puts "Общее количество мест:"
    count = gets.to_i
    PassengerWagon.new(count)
  when 2
    puts "Общий объем:"
    count = gets.to_i
    CargoWagon.new(count)
  end
end

def wagon_type
  puts "Тип (1 - пассажирский, 2 - грузовой):"
  gets.to_i
end

def remove_wagon
  return unless train

  train.remove_wagon if train
  puts train
end

def move_train_to_next_station
  return unless train

  train.next_station
  puts train
end

def show_stations_and_trains
  Train.trains.size > 0 ? (puts Train.trains) : (puts "Нет поездов")
  @stations.size > 0 ? (puts @stations) : (puts "Нет станций")
end

def train
  trains = Train.trains
  if trains.size == 1
    trains[0]
  elsif trains.size > 0
    puts "Номер поезда:"
    n = gets.to_s2
    trains[n.to_sym]
  end
end

def enumerate_stations
  proc_train = proc do |t|
    puts "#{t.train_number}-#{t.type}-#{t.length}"
    proc_wagon = proc { |w, i| puts "#{i}-#{w}" }
    t.call_wagons(proc_wagon)
  end
  puts @stations
  @stations.each { |s| s.call_trains(proc_train) }
end

loop do
  puts menu
  print '(1-8):'
  n = gets.to_i

  case n
  when 1
    create_station
  when 2
    create_train
  when 3
    add_wagon
  when 4
    remove_wagon
  when 5
    move_train_to_next_station
  when 6
    show_stations_and_trains
  when 7
    Train.all
  when 8
    enumerate_stations
  end
end
