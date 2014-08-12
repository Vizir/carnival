class Carnival::AvatarPresenter < Carnival::BaseAdminPresenter
  field :photo,
    :actions => [:new, :edit],
    :show_view => 'shared/carnival/photo_field',
    :as => 'admin_previewable_file'
end
