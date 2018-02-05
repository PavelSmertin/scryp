class Job
	def self.run(time = Time.zone.now)
		@logger.info "JOBS: START"
    	@logger.info "DATE #{time.to_date}"

		@logger.info "JOBS: price_updater"
		price_updater = Job::PriceUpdater.new
		price_updater.update

		@logger.info "JOBS: portfolio_calculator"
		portfolio_calculator = Job::PortfolioCalculator.new
		portfolio_calculator.calculate_all

		@logger.info "JOBS: END"
	end

	@logger = Logger.new("#{Rails.root}/log/job.log")
end