install.packages("rsconnect")

rsconnect::setAccountInfo(name='rushabh-wadkar', token='CADF00E4B25D410CCEF5F32891ABE764', secret='YQHlkLtDjyClwLnW/WtPLYGEFq+/d/lLq/g+6+JS')

rsconnect::deployApp('ui.R')