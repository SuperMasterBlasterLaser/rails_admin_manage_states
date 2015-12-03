require "rails_admin_manage_states/engine"

module RailsAdminManageStates
end

module RailsAdmin
	module Config
		module Actions
			class ManageStates < RailsAdmin::Config::Actions::Base
				RailsAdmin::Config::Actions.register(self)
			
				# This ensures the action only shows up for Authorized Persons
				register_instance_option :visible? do
					authorized? # && bindings[:object].has_attribute?(:state)
				end
				
				# We want the action on members
				register_instance_option :member do
					true
				end
				
				register_instance_option :link_icon do
					'icon-ok'
				end
				
				# You may or may not want pjax for your action
				register_instance_option :pjax? do
					false
				end

				register_instance_option :http_methods do
					[:get, :post]
				end

				register_instance_option :controller do
					Proc.new do
						if request.get?

							respond_to do |format|
								format.html { render @action.template_name }
								format.js   { render @action.template_name, layout: false }
							end

						elsif request.post?

							unless @authorization_adapter.nil? || @authorization_adapter.authorized?(:all_events, @abstract_model, @object)
								@authorization_adapter.try(:authorize, params[:state_events].to_sym, @abstract_model, @object)
							end

							if params['id'].present?

							#	puts "STATE EVENTS #{params[@abstract_model.param_key][:state_events]} Abstract model #{@abstract_model}"


								if @object.has_attribute?(:updater_id)
									@object.updater = _current_user
									puts @object.updater
									@object.save
								end


								begin
									if @object.send('fire_state_event', params[@abstract_model.param_key][:state_events].to_sym)
										@object.save
										flash[:success] = I18n.t('admin.actions.manage_states.event_fired', attr: params[:method], event: I18n.t("state_machines.events.#{params[@abstract_model.param_key][:state_events].to_s.mb_chars.downcase}"))
									else
										flash[:error] = obj.errors.full_messages.join(', ')
									end
								rescue StandardError => e
									Rails.logger.error e
									flash[:error] = I18n.t('admin.actions.manage_states.error', err: e.to_s)
								end

							else
								flash[:error] = I18n.t('admin.actions.manage_states.no_id')
							end

							redirect_to :back
						end
					end

				end
				
			end
		end
	end
end
