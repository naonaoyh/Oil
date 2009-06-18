class FireTheftCoverage < ActiveRecord::Base
hash_one :FireTheftCoverageFinancials
end
class FireTheftCoverageFinancials < ActiveRecord::Base
hash_one :FireTheftCoverageFinancialsExcess
hash_one :FireTheftCoverageFinancialsSumInsured
hash_one :FireTheftCoverageFinancialsPremiumQuoteBreakdown
end
class FireTheftCoverageFinancialsExcess < ActiveRecord::Base
end
class FireTheftCoverageFinancialsSumInsured < ActiveRecord::Base
end
class FireTheftCoverageFinancialsPremiumQuoteBreakdown < ActiveRecord::Base
end
