<?php

namespace App\Providers;

use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Pagination\Paginator;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
Relation::morphMap([
        'student' => 'App\Models\Student',
        'teacher' => 'App\Models\Teacher',
        'caregiver'  => 'App\Models\Caregiver',]);



        if (config('app.url')) {
            URL::forceRootUrl(config('app.url'));
        }
        Paginator::useBootstrapFive();
        if (str_starts_with(config('app.url'), 'https://')) {
            URL::forceScheme('https');
        }
    }
}
