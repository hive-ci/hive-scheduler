TESTMINE = { url: Chamber.env.testmine.url }.with_indifferent_access
Rails.application.config.testmine_url = TESTMINE['url']
