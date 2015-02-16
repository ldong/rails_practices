class IssueMailer < ApplicationMailer
  default from: 'rails@issues.com'

  def issue_created(issue)
    @issue = issue
    mail subject: 'A new issue was created', to: 'JPIILIN+rails@gmail.com'
  end
end
