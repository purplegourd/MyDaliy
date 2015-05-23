import Foundation

class Encoders
{
    class func md5( input:String ) -> String
    {
        let block_len = Int(CC_MD5_DIGEST_LENGTH)
        var buffer = UnsafeMutablePointer<UInt8>.alloc( block_len )
        var in_str = (input as NSString).UTF8String
        CC_MD5( in_str, (CC_LONG)(strlen(in_str)), buffer )
        var output = NSMutableString()
        for var i = 0; i < block_len ; ++i
        {
            output.appendFormat( "%02x", buffer[i] )
        }
        free( buffer )
        return output as String
    }
    
    class func encodeJSON( input_obj:AnyObject!  ) -> String
    {
        if( input_obj == nil ) { return "" }
        let json_data = NSJSONSerialization.dataWithJSONObject( input_obj, options: NSJSONWritingOptions.allZeros, error: nil )
        if( json_data == nil ) { return "" }
        let result = NSString( data:json_data!, encoding: NSUTF8StringEncoding )
        if( result == nil ) { return "" }

            return (String)(result!)
        
    }
    
    class func decodeJSON( input_str:String! ) -> AnyObject!
    {
        if( input_str == nil ) { return nil }
        var json_str:String
     
        json_str = input_str
        
        let json_data = json_str.dataUsingEncoding( NSUTF8StringEncoding, allowLossyConversion: false )
        if( json_data == nil ) { return nil }
        let json_obj:AnyObject? = NSJSONSerialization.JSONObjectWithData( json_data!, options: NSJSONReadingOptions.MutableContainers|NSJSONReadingOptions.MutableContainers, error: nil )
        return json_obj
    }
    
    static func encodeBase64( input:String ) -> String!
    {
        return input.dataUsingEncoding( NSUTF8StringEncoding )?.base64EncodedStringWithOptions( NSDataBase64EncodingOptions.allZeros )
    }
    
    static func decodeBase64( input:String ) -> String!
    {
        return NSString(data: NSData(base64EncodedString: input, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )!, encoding: NSUTF8StringEncoding ) as! String
    }
    
    
    static func encodeBase64Data( input:NSData ) -> String!
    {
        return input.base64EncodedStringWithOptions( NSDataBase64EncodingOptions.allZeros )
    }
    
    static func decodeBase64Data( input:String ) -> NSData!
    {
        return NSData(base64EncodedString: input, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )!
    }
    
    
}