module Components::ListHelper
  def list_item(value:, name:, action:, selected: false, as: :div)
    content_tag as, name,
                class: "relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm
         outline-none aria-selected:bg-accent aria-selected:text-accent-foreground hover:bg-accent hover:text-accent-foreground
         data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
                role: 'option',
                data: { value:, selected:, action: },
                aria: { selected: }
  end
end
