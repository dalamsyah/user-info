<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->text('address')->nullable()->after('phone');
            $table->json('hobbies')->nullable()->after('address');
            $table->json('favorite_foods')->nullable()->after('hobbies');
            $table->float('height')->nullable()->after('favorite_foods')->comment('Height in centimeters');
            $table->float('weight')->nullable()->after('height')->comment('Weight in kilograms');
            $table->date('birthdate')->nullable()->after('weight');
            $table->string('occupation')->nullable()->after('birthdate');
            $table->json('social_media_links')->nullable()->after('occupation');
            $table->string('website')->nullable()->after('social_media_links');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'address', 
                'hobbies', 
                'favorite_foods', 
                'height', 
                'weight', 
                'birthdate',
                'occupation', 
                'social_media_links',
                'website'
            ]);
        });
    }
};
