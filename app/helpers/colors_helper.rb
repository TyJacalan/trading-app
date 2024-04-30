module ColorsHelper
  def generate_random_colors(base_color_range, count)
    unless base_color_range.is_a?(Range) && base_color_range.min < base_color_range.max
      raise ArgumentError, "Invalid base color range"
    end

    colors = []
    count.times do
      base_color = rand(base_color_range)
      hue = (base_color + rand(-20..20)) % 360  # Vary the hue ±20 degrees
      saturation = rand(50..100)  # Vary the saturation between 50% and 100%
      lightness = rand(40..60)    # Vary the lightness between 40% and 60%
      colors << hsl_to_hex(hue, saturation, lightness)
    end
    colors
  end

  private

  def hsl_to_hex(h, s, l)
    h /= 360.0
    s /= 100.0
    l /= 100.0

    if s == 0
      r = g = b = l
    else
      q = l < 0.5 ? l * (1 + s) : l + s - l * s
      p = 2 * l - q
      r = hue_to_rgb(p, q, h + 1/3.0)
      g = hue_to_rgb(p, q, h)
      b = hue_to_rgb(p, q, h - 1/3.0)
    end

    "##{rgb_to_hex(r * 255)}#{rgb_to_hex(g * 255)}#{rgb_to_hex(b * 255)}"
  end

  def hue_to_rgb(p, q, t)
    t += 1 if t < 0
    t -= 1 if t > 1
    return p + (q - p) * 6 * t if t < 1/6.0
    return q if t < 1/2.0
    return p + (q - p) * (2/3.0 - t) * 6 if t < 2/3.0
    p
  end

  def rgb_to_hex(rgb)
    hex = rgb.round.clamp(0, 255).to_s(16)
    hex.rjust(2, '0')
  end
end
