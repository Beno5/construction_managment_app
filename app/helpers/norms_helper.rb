module NormsHelper
  def norm_disabled?(norm, pinned_norms)
    # Ako ova norma NIJE pinned → onda provjeri da li postoji druga pinned norma istog tipa
    return false if pinned_norms.include?(norm)

    if norm.worker?
      pinned_norms.any? do |pn|
        pn.worker? && pn.subtype == norm.subtype
      end
    else
      pinned_norms.any? do |pn|
        pn.norm_type == norm.norm_type
      end
    end
  end

  def norm_disabled_by_unit?(norm, pinned_norms)
    return false if pinned_norms.include?(norm)
    return false if pinned_norms.empty?

    # Uzmemo referentnu jedinicu mjere iz prve pinned norme
    selected_unit = pinned_norms.first.unit_of_measure

    # Ako norma ima drugu jedinicu, disable-uj je
    norm.unit_of_measure != selected_unit
  end
end
