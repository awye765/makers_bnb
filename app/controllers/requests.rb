class MakersBnb < Sinatra::Base
  post '/request/new' do
    space = Space.get(params[:space_id])
    booking_from = space.bookings.map(&:from_date)
    booking_to = space.bookings.map(&:end_date)
    request_range=(params[:start_date]..params[:end_date])
    check_booking_from_date(booking_from, request_range)
    check_booking_to_date(booking_to, request_range)
    request = Request.create(start_date: params[:start_date],
                             end_date: params[:end_date],
                             status: "Not Confirmed",
                             user_id: current_user.id, 
                             space_id: params[:space_id])
    if request.saved?
      flash.next[:saved] = ['Your booking request has been sent']
      redirect('/spaces')
    end

  end

  get '/requests' do
    user = current_user
    @spaces = user.spaces
    erb :requests
  end

  get '/requests/confirm/:id' do
    @booking_request = Request.get(params[:id])
    @space = Space.get(@booking_request.space_id)
    erb :confirm_requests
  end

  post '/request/confirm' do
    Request.first(id: params[:id]).update(status: "Confirmed") 
    request = Request.get(params[:id])   
    Booking.create(from_date: request.start_date, 
                   end_date: request.end_date, 
                   user_id:request.user_id, 
                   space_id: request.space_id)
    redirect('/requests')
  end
end
