json.extract! @student, :id, :name, :created_at, :updated_at

<script type="text/javascript" charset="utf-8">
    $(function(){
        d3.json( url, function( error, data ) {
        console.log( data );
        console.log("test");
        // do all actions required now that the data is retrieved
    } );

    });
</script>
