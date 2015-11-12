def compute_sku( vendor, serial, board_serial )

  # Sanitize params
  strip_pattern = /[^-^:\p{Alnum}]/
  serial        = (serial || '').gsub(strip_pattern,'')
  vendor        = (vendor || '').gsub(strip_pattern,'')
  board_serial  = (board_serial || '').gsub(strip_pattern,'')

  if not board_serial.empty?
    serial = board_serial
  end

  case vendor
    when "DellInc"
      sku="DEL"
    when "Supermicro"
      sku="SPM"
    else
      sku="UKN" # unknown manufacturer
  end

  sku="#{sku}-#{serial}"
  return sku
end

def clean_params(params)
  params.delete_if { |x,_| x == 'splat' || x == 'captures' }
  params
end
