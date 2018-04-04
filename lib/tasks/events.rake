namespace :events do
  desc "TODO"
  task process: :environment do
    logger = Logger.new(STDOUT)

    loop do
      batch = Batch.create(size: 10, interval: 1.minute)
      logger.info("created a batch with ID #{batch.id}")

      while !batch.full? do
        event = Event.where(batch_id: nil).order("created_at ASC").first

        if event.nil?
          next if batch.empty?
          break if Time.now > (batch.events.first.created_at + batch.interval)
          next
        end

        break if batch.outside_of_interval?(event)

        if batch.add(event)
          logger.info("event with ID #{event.id} has been added to batch")
        end
      end

      logger.info("running batch")
      batch.run
      logger.info("batch has been run")
    rescue => ex
      logger.error("got error when processing batch #{ex.message}")
      raise
    end
  end
end
