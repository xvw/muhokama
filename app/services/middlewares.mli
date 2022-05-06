val user_authenticated : Dream.middleware
val user_not_authenticated : Dream.middleware
val user_required : (Models.User.t -> Dream.handler) -> Dream.handler
val moderator_required : (Models.User.t -> Dream.handler) -> Dream.handler
val administrator_required : (Models.User.t -> Dream.handler) -> Dream.handler
