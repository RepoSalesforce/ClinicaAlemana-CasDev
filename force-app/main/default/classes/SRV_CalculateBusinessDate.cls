global class SRV_CalculateBusinessDate {
    @InvocableMethod(label='Calculate Future date W/BusinessHours' description='Take in count the Business Hours and Holidays' category='Case')
    public static List<Results> calculateDateTime(List<dateRequest> dateRequests) {
        List<BusinessHours> bhs = [Select id from BusinessHours where name ='Horario atención CAS'];
        List<Results> result = new List<Results>();
        for(dateRequest dr : dateRequests){
            if(dr.CaseId != null && dr.StartDate != Null && dr.Hours != Null){
                long milliSeconds = long.valueOf(dr.Hours) * 3600000;
                Datetime resultDateCalculation = BusinessHours.add(bhs[0].id,dr.StartDate, milliSeconds);
                Results res = new Results();
                res.resultDate = resultDateCalculation;
                res.startDate = BusinessHours.nextStartDate(bhs[0].id, dr.StartDate);
                res.CaseId = dr.CaseID;
                result.add(res);
            }
        }
        return result;
    }
    global class dateRequest{
        @InvocableVariable(label='StartDate for the calculation' description='' required=true)
        global Datetime StartDate;
        @InvocableVariable(label='Number of hours to calculate the date' description='' required=true)
        global String Hours;
        @InvocableVariable(label='Case Related' description='' required=true)
        global ID CaseID;
    }
    public class Results {
        @InvocableVariable(label='DateTime result' description='')
        public DateTime resultDate;
        @InvocableVariable(label='Start counting DateTime ' description='')
        public DateTime startDate;
        @InvocableVariable(label='Case Related' description ='' required=true)
        public ID CaseID;
    }
}