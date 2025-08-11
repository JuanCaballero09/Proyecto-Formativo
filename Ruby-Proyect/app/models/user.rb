class User < ApplicationRecord
  has_many :orders, dependent: :destroy

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Enum roles
  enum :rol, { cliente: 0, empleado: 1, admin: 2 }

  # Valores por defecto
  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.rol ||= ":cliente"
    self.activo ||= true if activo.nil?
    self.fecha_registro ||= Date.today
  end

  # Validaciones
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :telefono, presence: true

  # Permitir login si está confirmado o es admin
  def active_for_authentication?
    super && (confirmed? || admin?)
  end
end
