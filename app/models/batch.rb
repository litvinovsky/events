class Batch < ApplicationRecord
  has_many :events

  def add(event)
    raise "You are trying to add to already processed batch" if processed?
    raise "You are trying to add to batch which is already full" if full?

    event.with_lock do
      return if event.batch_id

      !!event.update_attribute(:batch_id, id)
    end
  end

  def full?
    events.count >= size
  end

  def empty?
    events.count == 0
  end

  def run
    raise "You are trying to run already processed batch" if processed?

    socket = TCPSocket.open('localhost', 8080)
    socket.print(events.to_a.join(','))
    socket.close

    update_attribute(:processed, true)
  end

  def outside_of_interval?(event)
    if empty?
      return false
    else
      event.created_at > (events.first.created_at + interval)
    end
  end
end


