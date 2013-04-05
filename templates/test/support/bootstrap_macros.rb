module BoostrapMacros
  def inline_error_for(id, assertions)
    within("##{id} + .help-inline") do
      assertions.each do |assertion, value|
        page.text.send assertion, value
      end
    end
  end
end
